--圣天树的开花
function c100270218.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,100270218+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100270218.acttg)
	e1:SetOperation(c100270218.actop)
	c:RegisterEffect(e1)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100270218,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,100270218)
	e1:SetCondition(c100270218.atkcon)
	e1:SetTarget(c100270218.atktg)
	e1:SetOperation(c100270218.atkop)
	c:RegisterEffect(e1)
end
function c100270218.lkfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsType(TYPE_LINK) and c:IsLinkAbove(4)
end
function c100270218.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lk=Duel.GetMatchingGroupCount(c100270218.lkfilter,tp,LOCATION_MZONE,0,nil)
	if lk>0 then
		local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	end
end
function c100270218.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local lk=Duel.GetMatchingGroupCount(c100270218.lkfilter,tp,LOCATION_MZONE,0,nil)
	if lk>0 then
		local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end
function c100270218.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetAttacker(),Duel.GetAttackTarget()
	return (a:IsControler(tp) and a:IsRace(RACE_PLANT) and a:IsType(TYPE_LINK))
		or (not d or (d:IsControler(tp) and d:IsRace(RACE_PLANT) and d:IsType(TYPE_LINK)))
end
function c100270218.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return #lg>0 and lg:GetSum(Card.GetAttack)>0 end
end
function c100270218.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local lg=e:GetHandler():GetLinkedGroup()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(lg:GetSum(Card.GetAttack))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end