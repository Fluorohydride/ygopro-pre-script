--黄金郷のガーディアン
--
--Script by JustFish
function c100414032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100414032,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100414032)
	e1:SetTarget(c100414032.target)
	e1:SetOperation(c100414032.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100414032,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100414032)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100414032.settg)
	e2:SetOperation(c100414032.setop)
	c:RegisterEffect(e2)
end
function c100414032.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c100414032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,100414032,0,0x11,800,2500,8,RACE_ZOMBIE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100414032.filter(c)
	return c:IsFaceup() and c:IsCode(100414027)
end
function c100414032.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,100414032,0,0x11,800,2500,8,RACE_ZOMBIE,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(c100414032.filter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c100414032.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(100414032,2)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c100414032.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function c100414032.setfilter(c)
	return c:IsSetCard(0x244) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c100414032.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100414032.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c100414032.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c100414032.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
