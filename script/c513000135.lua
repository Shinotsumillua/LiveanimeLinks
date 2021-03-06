--The God of Obelisk
--マイケル・ローレンス・ディーによってスクリプト
--scripted by MLD
--credit to TPD & Cybercatman
--updated by Larry126
function c513000135.initial_effect(c)
	aux.CallToken(421)
	--Summon with 3 Tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c513000135.sumoncon)
	e1:SetOperation(c513000135.sumonop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e2)
	--destory
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4012,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c513000135.atkcost)
	e3:SetTarget(c513000135.destg)
	e3:SetOperation(c513000135.desop)
	c:RegisterEffect(e3)
	--Soul Energy Max
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4012,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c513000135.atkcost)
	e4:SetCondition(c513000135.atkcon)
	e4:SetOperation(c513000135.atkop)
	c:RegisterEffect(e4)
	if not c513000135.global_check then
		c513000135.global_check=true
		--avatar
		local av=Effect.CreateEffect(c)
		av:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		av:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		av:SetCode(EVENT_ADJUST)
		av:SetCondition(c513000135.avatarcon)
		av:SetOperation(c513000135.avatarop)
		Duel.RegisterEffect(av,0)
	end
end
function c513000135.avfilter(c)
	local atktes={c:GetCardEffect(EFFECT_SET_ATTACK_FINAL)}
	local ae=nil
	local de=nil
	for _,atkte in ipairs(atktes) do
		if atkte:GetOwner()==c and atkte:IsHasProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY) then
			ae=atkte:GetLabel()
		end
	end
	local deftes={c:GetCardEffect(EFFECT_SET_DEFENSE_FINAL)}
	for _,defte in ipairs(deftes) do
		if defte:GetOwner()==c and defte:IsHasProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY) then
			de=defte:GetLabel()
		end
	end
	return c:GetOriginalCode()==21208154 and (ae~=9999999 or de~=9999999)
end
function c513000135.avatarcon(e,tp,eg,ev,ep,re,r,rp)
	return Duel.GetMatchingGroupCount(c513000135.avfilter,tp,0xff,0xff,nil)>0
end
function c513000135.avatarop(e,tp,eg,ev,ep,re,r,rp)
	local g=Duel.GetMatchingGroup(c513000135.avfilter,tp,0xff,0xff,nil)
	g:ForEach(function(c)
		local atktes={c:GetCardEffect(EFFECT_SET_ATTACK_FINAL)}
		for _,atkte in ipairs(atktes) do
			if atkte:GetOwner()==c and atkte:IsHasProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY) then
				atkte:SetValue(c513000135.avaval)
				atkte:SetLabel(9999999)
			end
		end
		local deftes={c:GetCardEffect(EFFECT_SET_DEFENSE_FINAL)}
		for _,defte in ipairs(deftes) do
			if defte:GetOwner()==c and defte:IsHasProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY) then
				defte:SetValue(c513000135.avaval)
				defte:SetLabel(9999999)
			end
		end
	end)
end
function c513000135.avafilter(c)
	return c:IsFaceup() and c:GetCode()~=21208154
end
function c513000135.avaval(e,c)
	local g=Duel.GetMatchingGroup(c513000135.avafilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then 
		return 100
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		if val>=9999999 then
			return val
		else
			return val+100
		end
	end
end
-------------------------------------------------------------------
function c513000135.sumoncon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3 and Duel.GetTributeCount(c)>=3
end
function c513000135.sumonop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
-----------------------------------------------------------------
function c513000135.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),1-tp,LOCATION_MZONE)
end
function c513000135.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER),e:GetHandler():GetAttack(),REASON_EFFECT)
	Duel.Destroy(Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil),REASON_EFFECT)
end
-----------------------------------------------------------------
function c513000135.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,2,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,nil,2,2,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c513000135.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
		and e:GetHandler():IsAttackable()
end
function c513000135.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE+PHASE_BATTLE+PHASE_END)
		e1:SetValue(c513000135.adval)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e2:SetCondition(c513000135.damcon)
		e2:SetOperation(c513000135.damop)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE+PHASE_BATTLE+PHASE_END)
		c:RegisterEffect(e2)
		Duel.BreakEffect()
		local ag,direct=c:GetAttackableTarget()
		if direct and ag:GetCount()>0 then
			if Duel.SelectYesNo(tp,aux.Stringid(41077745,0)) then
				Duel.CalculateDamage(c,nil)
			else
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(36708764,0))
				Duel.CalculateDamage(c,ag:Select(tp,1,1,nil):GetFirst())
			end
		elseif ag:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(36708764,0))
			Duel.CalculateDamage(c,ag:Select(tp,1,1,nil):GetFirst())
		elseif direct then
			Duel.CalculateDamage(c,nil)
		end
	end
end
function c513000135.adval(e,c)
	local g=Duel.GetMatchingGroup(nil,0,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if g:GetCount()==0 then 
		return 9999999
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		if val<=9999999 then
			return 9999999
		else
			return val
		end
	end
end
function c513000135.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetAttack()>=9999999
end
function c513000135.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,Duel.GetLP(ep)*100)
end